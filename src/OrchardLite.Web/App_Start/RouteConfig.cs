using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace OrchardLite.Web
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            // Content routes
            routes.MapRoute(
                name: "ContentDetails",
                url: "content/{id}",
                defaults: new { controller = "Content", action = "Details" },
                constraints: new { id = @"^[a-zA-Z0-9\-]+$" }
            );

            routes.MapRoute(
                name: "Blog",
                url: "blog",
                defaults: new { controller = "Content", action = "Blog" }
            );

            routes.MapRoute(
                name: "Pages",
                url: "pages",
                defaults: new { controller = "Content", action = "Pages" }
            );

            routes.MapRoute(
                name: "Search",
                url: "search",
                defaults: new { controller = "Content", action = "Search" }
            );

            // Admin routes
            routes.MapRoute(
                name: "Admin",
                url: "admin/{action}/{id}",
                defaults: new { controller = "Admin", action = "Index", id = UrlParameter.Optional }
            );

            // Default route
            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}