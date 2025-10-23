using System;
using System.Linq;
using System.Web.Mvc;
using OrchardLite.Web.Models;

namespace OrchardLite.Web.Controllers
{
    public class ContentController : Controller
    {
        private readonly OrchardLiteContext _context;

        public ContentController()
        {
            _context = new OrchardLiteContext();
        }

        // GET: Content/Details/slug
        public ActionResult Details(string id)
        {
            if (string.IsNullOrEmpty(id))
            {
                return HttpNotFound();
            }

            var contentItem = _context.ContentItems
                .Include("Author")
                .Include("ContentParts")
                .FirstOrDefault(c => c.Slug == id && c.Status == ContentStatus.Published && !c.IsDeleted);

            if (contentItem == null)
            {
                return HttpNotFound();
            }

            // Increment view count
            contentItem.ViewCount++;
            _context.SaveChanges();

            // Get related content
            var relatedContent = _context.ContentItems
                .Where(c => c.ContentType == contentItem.ContentType && 
                           c.Id != contentItem.Id && 
                           c.Status == ContentStatus.Published && 
                           !c.IsDeleted)
                .OrderByDescending(c => c.PublishedDate)
                .Take(3)
                .ToList();

            var viewModel = new ContentDetailsViewModel
            {
                ContentItem = contentItem,
                RelatedContent = relatedContent,
                CanEdit = false // TODO: Implement user authentication and authorization
            };

            return View(viewModel);
        }

        // GET: Content/Blog
        public ActionResult Blog(int page = 1, int pageSize = 10)
        {
            var blogPosts = _context.ContentItems
                .Include("Author")
                .Where(c => c.ContentType == "BlogPost" && c.Status == ContentStatus.Published && !c.IsDeleted)
                .OrderByDescending(c => c.PublishedDate)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewBag.CurrentPage = page;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalPosts = _context.ContentItems
                .Count(c => c.ContentType == "BlogPost" && c.Status == ContentStatus.Published && !c.IsDeleted);

            return View(blogPosts);
        }

        // GET: Content/Pages
        public ActionResult Pages()
        {
            var pages = _context.ContentItems
                .Include("Author")
                .Where(c => c.ContentType == "Page" && c.Status == ContentStatus.Published && !c.IsDeleted)
                .OrderBy(c => c.Title)
                .ToList();

            return View(pages);
        }

        // GET: Content/Search
        public ActionResult Search(string q, int page = 1, int pageSize = 10)
        {
            if (string.IsNullOrWhiteSpace(q))
            {
                ViewBag.Query = "";
                ViewBag.Results = new ContentItem[0];
                ViewBag.TotalResults = 0;
                return View();
            }

            var searchTerm = q.Trim().ToLower();
            
            var results = _context.ContentItems
                .Include("Author")
                .Where(c => c.Status == ContentStatus.Published && 
                           !c.IsDeleted &&
                           (c.Title.ToLower().Contains(searchTerm) ||
                            c.Summary.ToLower().Contains(searchTerm) ||
                            c.Body.ToLower().Contains(searchTerm)))
                .OrderByDescending(c => c.PublishedDate)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewBag.Query = q;
            ViewBag.Results = results;
            ViewBag.CurrentPage = page;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalResults = _context.ContentItems
                .Count(c => c.Status == ContentStatus.Published && 
                           !c.IsDeleted &&
                           (c.Title.ToLower().Contains(searchTerm) ||
                            c.Summary.ToLower().Contains(searchTerm) ||
                            c.Body.ToLower().Contains(searchTerm)));

            return View();
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