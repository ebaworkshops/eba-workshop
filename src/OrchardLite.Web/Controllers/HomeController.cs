using System;
using System.Linq;
using System.Web.Mvc;
using OrchardLite.Web.Models;

namespace OrchardLite.Web.Controllers
{
    public class HomeController : Controller
    {
        private readonly OrchardLiteContext _context;

        public HomeController()
        {
            _context = new OrchardLiteContext();
        }

        public ActionResult Index()
        {
            var viewModel = new HomeViewModel
            {
                RecentPosts = _context.ContentItems
                    .Where(c => c.ContentType == "BlogPost" && c.Status == ContentStatus.Published && !c.IsDeleted)
                    .OrderByDescending(c => c.PublishedDate)
                    .Take(5)
                    .ToList(),
                
                Pages = _context.ContentItems
                    .Where(c => c.ContentType == "Page" && c.Status == ContentStatus.Published && !c.IsDeleted)
                    .OrderBy(c => c.Title)
                    .ToList(),
                
                SiteName = GetSetting("SiteName", "OrchardLite CMS"),
                SiteDescription = GetSetting("SiteDescription", "A lightweight CMS for AWS migration workshops")
            };

            return View(viewModel);
        }

        public ActionResult About()
        {
            ViewBag.Message = "About OrchardLite CMS";
            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Contact us for support and questions.";
            return View();
        }

        public ActionResult Error()
        {
            return View();
        }

        private string GetSetting(string key, string defaultValue = "")
        {
            try
            {
                var setting = _context.Settings.FirstOrDefault(s => s.SettingKey == key);
                return setting?.SettingValue ?? defaultValue;
            }
            catch
            {
                return defaultValue;
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