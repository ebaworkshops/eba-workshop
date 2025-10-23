using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OrchardLite.Web.Models
{
    public enum ContentStatus
    {
        Draft,
        Published,
        Archived
    }

    [Table("ContentItems")]
    public class ContentItem
    {
        public ContentItem()
        {
            ContentParts = new HashSet<ContentPart>();
            Status = ContentStatus.Draft;
            CreatedDate = DateTime.UtcNow;
            ModifiedDate = DateTime.UtcNow;
            ViewCount = 0;
            IsDeleted = false;
        }

        public int Id { get; set; }

        [Required]
        [StringLength(100)]
        public string ContentType { get; set; }

        [Required]
        [StringLength(500)]
        public string Title { get; set; }

        [Required]
        [StringLength(500)]
        public string Slug { get; set; }

        public string Summary { get; set; }

        public string Body { get; set; }

        public int AuthorId { get; set; }

        public ContentStatus Status { get; set; }

        public DateTime? PublishedDate { get; set; }

        public DateTime CreatedDate { get; set; }

        public DateTime ModifiedDate { get; set; }

        public int ViewCount { get; set; }

        public bool IsDeleted { get; set; }

        // Navigation properties
        public virtual User Author { get; set; }
        public virtual ICollection<ContentPart> ContentParts { get; set; }

        [NotMapped]
        public bool IsPublished => Status == ContentStatus.Published && PublishedDate.HasValue && PublishedDate <= DateTime.UtcNow;

        [NotMapped]
        public string StatusDisplay => Status.ToString();
    }

    [Table("ContentParts")]
    public class ContentPart
    {
        public ContentPart()
        {
            CreatedDate = DateTime.UtcNow;
        }

        public int Id { get; set; }

        public int ContentItemId { get; set; }

        [Required]
        [StringLength(100)]
        public string PartType { get; set; }

        [Required]
        [StringLength(100)]
        public string PartName { get; set; }

        public string PartData { get; set; }

        public DateTime CreatedDate { get; set; }

        // Navigation properties
        public virtual ContentItem ContentItem { get; set; }
    }

    [Table("MediaItems")]
    public class MediaItem
    {
        public MediaItem()
        {
            UploadedDate = DateTime.UtcNow;
            IsDeleted = false;
        }

        public int Id { get; set; }

        [Required]
        [StringLength(255)]
        public string FileName { get; set; }

        [Required]
        [StringLength(255)]
        public string OriginalFileName { get; set; }

        [Required]
        [StringLength(100)]
        public string ContentType { get; set; }

        public long FileSize { get; set; }

        [Required]
        [StringLength(1000)]
        public string FilePath { get; set; }

        [StringLength(500)]
        public string AltText { get; set; }

        public string Caption { get; set; }

        public int UploadedById { get; set; }

        public DateTime UploadedDate { get; set; }

        public bool IsDeleted { get; set; }

        // Navigation properties
        public virtual User UploadedBy { get; set; }

        [NotMapped]
        public string FileSizeFormatted
        {
            get
            {
                string[] sizes = { "B", "KB", "MB", "GB", "TB" };
                double len = FileSize;
                int order = 0;
                while (len >= 1024 && order < sizes.Length - 1)
                {
                    order++;
                    len = len / 1024;
                }
                return $"{len:0.##} {sizes[order]}";
            }
        }

        [NotMapped]
        public bool IsImage => ContentType.StartsWith("image/");
    }

    [Table("Settings")]
    public class Setting
    {
        public Setting()
        {
            Category = "General";
            IsSystemSetting = false;
            ModifiedDate = DateTime.UtcNow;
        }

        public int Id { get; set; }

        [Required]
        [StringLength(255)]
        public string SettingKey { get; set; }

        public string SettingValue { get; set; }

        [StringLength(100)]
        public string Category { get; set; }

        public string Description { get; set; }

        public bool IsSystemSetting { get; set; }

        public DateTime ModifiedDate { get; set; }
    }

    // View Models for the application
    public class HomeViewModel
    {
        public IEnumerable<ContentItem> RecentPosts { get; set; }
        public IEnumerable<ContentItem> Pages { get; set; }
        public string SiteName { get; set; }
        public string SiteDescription { get; set; }
    }

    public class ContentDetailsViewModel
    {
        public ContentItem ContentItem { get; set; }
        public IEnumerable<ContentItem> RelatedContent { get; set; }
        public bool CanEdit { get; set; }
    }

    public class AdminDashboardViewModel
    {
        public int TotalUsers { get; set; }
        public int TotalContent { get; set; }
        public int TotalMedia { get; set; }
        public int PublishedContent { get; set; }
        public int DraftContent { get; set; }
        public IEnumerable<ContentItem> RecentContent { get; set; }
        public IEnumerable<AuditLog> RecentActivity { get; set; }
    }
}