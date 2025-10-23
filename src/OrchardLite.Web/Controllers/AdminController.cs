using System;
using System.Linq;
using System.Web.Mvc;
using OrchardLite.Web.Models;

namespace OrchardLite.Web.Controllers
{
    public class AdminController : Controller
    {
        private readonly OrchardLiteContext _context;

        public AdminController()
        {
            _context = new OrchardLiteContext();
        }

        // GET: Admin
        public ActionResult Index()
        {
            var viewModel = new AdminDashboardViewModel
            {
                TotalUsers = _context.Users.Count(u => u.IsActive),
                TotalContent = _context.ContentItems.Count(c => !c.IsDeleted),
                TotalMedia = _context.MediaItems.Count(m => !m.IsDeleted),
                PublishedContent = _context.ContentItems.Count(c => c.Status == ContentStatus.Published && !c.IsDeleted),
                DraftContent = _context.ContentItems.Count(c => c.Status == ContentStatus.Draft && !c.IsDeleted),
                
                RecentContent = _context.ContentItems
                    .Include("Author")
                    .Where(c => !c.IsDeleted)
                    .OrderByDescending(c => c.ModifiedDate)
                    .Take(10)
                    .ToList(),
                
                RecentActivity = _context.AuditLogs
                    .Include("User")
                    .OrderByDescending(a => a.CreatedDate)
                    .Take(20)
                    .ToList()
            };

            return View(viewModel);
        }

        // GET: Admin/Content
        public ActionResult Content(string contentType = "", string status = "", int page = 1, int pageSize = 20)
        {
            var query = _context.ContentItems.Include("Author").Where(c => !c.IsDeleted);

            if (!string.IsNullOrEmpty(contentType))
            {
                query = query.Where(c => c.ContentType == contentType);
            }

            if (!string.IsNullOrEmpty(status) && Enum.TryParse<ContentStatus>(status, out var statusEnum))
            {
                query = query.Where(c => c.Status == statusEnum);
            }

            var content = query
                .OrderByDescending(c => c.ModifiedDate)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewBag.ContentTypes = _context.ContentItems
                .Where(c => !c.IsDeleted)
                .Select(c => c.ContentType)
                .Distinct()
                .OrderBy(ct => ct)
                .ToList();

            ViewBag.CurrentContentType = contentType;
            ViewBag.CurrentStatus = status;
            ViewBag.CurrentPage = page;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalItems = query.Count();

            return View(content);
        }

        // GET: Admin/Users
        public ActionResult Users(int page = 1, int pageSize = 20)
        {
            var users = _context.Users
                .Include("UserRoles.Role")
                .OrderBy(u => u.UserName)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewBag.CurrentPage = page;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalUsers = _context.Users.Count();

            return View(users);
        }

        // GET: Admin/Media
        public ActionResult Media(int page = 1, int pageSize = 20)
        {
            var media = _context.MediaItems
                .Include("UploadedBy")
                .Where(m => !m.IsDeleted)
                .OrderByDescending(m => m.UploadedDate)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewBag.CurrentPage = page;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalMedia = _context.MediaItems.Count(m => !m.IsDeleted);

            return View(media);
        }

        // GET: Admin/Settings
        public ActionResult Settings()
        {
            var settings = _context.Settings
                .OrderBy(s => s.Category)
                .ThenBy(s => s.SettingKey)
                .ToList();

            return View(settings);
        }

        // GET: Admin/AuditLog
        public ActionResult AuditLog(int page = 1, int pageSize = 50)
        {
            var auditLogs = _context.AuditLogs
                .Include("User")
                .OrderByDescending(a => a.CreatedDate)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewBag.CurrentPage = page;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalLogs = _context.AuditLogs.Count();

            return View(auditLogs);
        }

        // GET: Admin/DatabaseInfo
        public ActionResult DatabaseInfo()
        {
            var dbInfo = new
            {
                TotalUsers = _context.Users.Count(),
                ActiveUsers = _context.Users.Count(u => u.IsActive),
                TotalRoles = _context.Roles.Count(),
                TotalContent = _context.ContentItems.Count(),
                PublishedContent = _context.ContentItems.Count(c => c.Status == ContentStatus.Published),
                DraftContent = _context.ContentItems.Count(c => c.Status == ContentStatus.Draft),
                TotalMedia = _context.MediaItems.Count(),
                TotalSettings = _context.Settings.Count(),
                TotalAuditLogs = _context.AuditLogs.Count(),
                DatabaseSize = GetDatabaseSize()
            };

            return View(dbInfo);
        }

        private string GetDatabaseSize()
        {
            try
            {
                var sizeQuery = @"
                    SELECT 
                        ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'DB Size in MB'
                    FROM information_schema.tables 
                    WHERE table_schema = DATABASE()";

                var result = _context.Database.SqlQuery<decimal>(sizeQuery).FirstOrDefault();
                return $"{result} MB";
            }
            catch
            {
                return "Unknown";
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                _context?.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}