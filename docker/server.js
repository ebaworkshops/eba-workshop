const express = require('express');
const mysql = require('mysql2/promise');
const path = require('path');
const bodyParser = require('body-parser');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use('/css', express.static(path.join(__dirname, 'public/css')));
app.use('/js', express.static(path.join(__dirname, 'public/js')));
app.use('/images', express.static(path.join(__dirname, 'public/images')));

// Set EJS as template engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Database connection
const dbConfig = {
  host: process.env.DB_HOST || 'mysql',
  user: process.env.DB_USER || 'orcharduser',
  password: process.env.DB_PASSWORD || 'OrchardPassword123!',
  database: process.env.DB_NAME || 'OrchardLiteDB',
  port: process.env.DB_PORT || 3306
};

let db;

// Initialize database connection
async function initDatabase() {
  try {
    db = await mysql.createConnection(dbConfig);
    console.log('✅ Connected to MySQL database');
    
    // Test the connection
    const [rows] = await db.execute('SELECT COUNT(*) as count FROM Users');
    console.log(`📊 Database ready - ${rows[0].count} users found`);
  } catch (error) {
    console.error('❌ Database connection failed:', error.message);
    console.log('🔄 Retrying in 5 seconds...');
    setTimeout(initDatabase, 5000);
  }
}

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Routes
app.get('/', async (req, res) => {
  try {
    // Get recent blog posts
    const [posts] = await db.execute(`
      SELECT c.*, u.FirstName, u.LastName 
      FROM ContentItems c 
      JOIN Users u ON c.AuthorId = u.Id 
      WHERE c.ContentType = 'BlogPost' AND c.Status = 'Published' 
      ORDER BY c.PublishedDate DESC 
      LIMIT 5
    `);

    // Get pages
    const [pages] = await db.execute(`
      SELECT * FROM ContentItems 
      WHERE ContentType = 'Page' AND Status = 'Published' 
      ORDER BY Title
    `);

    // Get site settings
    const [settings] = await db.execute(`
      SELECT SettingKey, SettingValue FROM Settings 
      WHERE SettingKey IN ('SiteName', 'SiteDescription')
    `);

    const siteSettings = {};
    settings.forEach(setting => {
      siteSettings[setting.SettingKey] = setting.SettingValue;
    });

    res.render('home', {
      title: 'Home',
      siteName: siteSettings.SiteName || 'OrchardLite CMS',
      siteDescription: siteSettings.SiteDescription || 'A lightweight CMS for AWS migration workshops',
      recentPosts: posts,
      pages: pages
    });
  } catch (error) {
    console.error('Error loading home page:', error);
    res.render('error', { error: error.message });
  }
});

app.get('/blog', async (req, res) => {
  try {
    const [posts] = await db.execute(`
      SELECT c.*, u.FirstName, u.LastName 
      FROM ContentItems c 
      JOIN Users u ON c.AuthorId = u.Id 
      WHERE c.ContentType = 'BlogPost' AND c.Status = 'Published' 
      ORDER BY c.PublishedDate DESC
    `);

    res.render('blog', {
      title: 'Blog',
      posts: posts
    });
  } catch (error) {
    console.error('Error loading blog:', error);
    res.render('error', { error: error.message });
  }
});

app.get('/content/:slug', async (req, res) => {
  try {
    const [content] = await db.execute(`
      SELECT c.*, u.FirstName, u.LastName 
      FROM ContentItems c 
      JOIN Users u ON c.AuthorId = u.Id 
      WHERE c.Slug = ? AND c.Status = 'Published'
    `, [req.params.slug]);

    if (content.length === 0) {
      return res.status(404).render('error', { error: 'Content not found' });
    }

    // Increment view count
    await db.execute('UPDATE ContentItems SET ViewCount = ViewCount + 1 WHERE Id = ?', [content[0].Id]);

    res.render('content-details', {
      title: content[0].Title,
      content: content[0]
    });
  } catch (error) {
    console.error('Error loading content:', error);
    res.render('error', { error: error.message });
  }
});

app.get('/admin', async (req, res) => {
  try {
    // Get dashboard statistics
    const [userCount] = await db.execute('SELECT COUNT(*) as count FROM Users WHERE IsActive = 1');
    const [contentCount] = await db.execute('SELECT COUNT(*) as count FROM ContentItems WHERE IsDeleted = 0');
    const [mediaCount] = await db.execute('SELECT COUNT(*) as count FROM MediaItems WHERE IsDeleted = 0');
    const [publishedCount] = await db.execute('SELECT COUNT(*) as count FROM ContentItems WHERE Status = "Published" AND IsDeleted = 0');
    const [draftCount] = await db.execute('SELECT COUNT(*) as count FROM ContentItems WHERE Status = "Draft" AND IsDeleted = 0');

    // Get recent content
    const [recentContent] = await db.execute(`
      SELECT c.*, u.FirstName, u.LastName 
      FROM ContentItems c 
      JOIN Users u ON c.AuthorId = u.Id 
      WHERE c.IsDeleted = 0 
      ORDER BY c.ModifiedDate DESC 
      LIMIT 10
    `);

    // Get recent activity
    const [recentActivity] = await db.execute(`
      SELECT a.*, u.FirstName, u.LastName 
      FROM AuditLogs a 
      LEFT JOIN Users u ON a.UserId = u.Id 
      ORDER BY a.CreatedDate DESC 
      LIMIT 20
    `);

    res.render('admin', {
      title: 'Admin Dashboard',
      stats: {
        totalUsers: userCount[0].count,
        totalContent: contentCount[0].count,
        totalMedia: mediaCount[0].count,
        publishedContent: publishedCount[0].count,
        draftContent: draftCount[0].count
      },
      recentContent: recentContent,
      recentActivity: recentActivity
    });
  } catch (error) {
    console.error('Error loading admin dashboard:', error);
    res.render('error', { error: error.message });
  }
});

app.get('/admin/databaseinfo', async (req, res) => {
  try {
    const tables = ['Users', 'Roles', 'UserRoles', 'ContentItems', 'ContentParts', 'MediaItems', 'Settings', 'AuditLogs'];
    const tableInfo = {};

    for (const table of tables) {
      const [count] = await db.execute(`SELECT COUNT(*) as count FROM ${table}`);
      tableInfo[table] = count[0].count;
    }

    // Get database size
    const [sizeInfo] = await db.execute(`
      SELECT 
        ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'size_mb'
      FROM information_schema.tables 
      WHERE table_schema = DATABASE()
    `);

    res.render('database-info', {
      title: 'Database Information',
      tableInfo: tableInfo,
      databaseSize: sizeInfo[0].size_mb || 'Unknown'
    });
  } catch (error) {
    console.error('Error loading database info:', error);
    res.render('error', { error: error.message });
  }
});

app.get('/about', (req, res) => {
  res.render('about', { title: 'About OrchardLite CMS' });
});

app.get('/contact', (req, res) => {
  res.render('contact', { title: 'Contact Us' });
});

// Error handler
app.use((req, res) => {
  res.status(404).render('error', { error: 'Page not found' });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 OrchardLite CMS Demo Server running on http://localhost:${PORT}`);
  console.log(`📊 Admin Dashboard: http://localhost:${PORT}/admin`);
  console.log(`🗄️  Database Info: http://localhost:${PORT}/admin/databaseinfo`);
  console.log(`📝 Blog: http://localhost:${PORT}/blog`);
  initDatabase();
});