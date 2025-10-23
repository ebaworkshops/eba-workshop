using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OrchardLite.Web.Models
{
    [Table("Users")]
    public class User
    {
        public User()
        {
            UserRoles = new HashSet<UserRole>();
            ContentItems = new HashSet<ContentItem>();
            MediaItems = new HashSet<MediaItem>();
            AuditLogs = new HashSet<AuditLog>();
            IsActive = true;
            CreatedDate = DateTime.UtcNow;
        }

        public int Id { get; set; }

        [Required]
        [StringLength(255)]
        public string UserName { get; set; }

        [Required]
        [StringLength(255)]
        [EmailAddress]
        public string Email { get; set; }

        [Required]
        [StringLength(500)]
        public string PasswordHash { get; set; }

        [StringLength(100)]
        public string FirstName { get; set; }

        [StringLength(100)]
        public string LastName { get; set; }

        public bool IsActive { get; set; }

        public DateTime CreatedDate { get; set; }

        public DateTime? LastLoginDate { get; set; }

        // Navigation properties
        public virtual ICollection<UserRole> UserRoles { get; set; }
        public virtual ICollection<ContentItem> ContentItems { get; set; }
        public virtual ICollection<MediaItem> MediaItems { get; set; }
        public virtual ICollection<AuditLog> AuditLogs { get; set; }

        [NotMapped]
        public string FullName => $"{FirstName} {LastName}".Trim();
    }

    [Table("Roles")]
    public class Role
    {
        public Role()
        {
            UserRoles = new HashSet<UserRole>();
            CreatedDate = DateTime.UtcNow;
        }

        public int Id { get; set; }

        [Required]
        [StringLength(100)]
        public string RoleName { get; set; }

        public string Description { get; set; }

        public bool IsSystemRole { get; set; }

        public DateTime CreatedDate { get; set; }

        // Navigation properties
        public virtual ICollection<UserRole> UserRoles { get; set; }
    }

    [Table("UserRoles")]
    public class UserRole
    {
        public UserRole()
        {
            AssignedDate = DateTime.UtcNow;
        }

        public int Id { get; set; }

        public int UserId { get; set; }

        public int RoleId { get; set; }

        public DateTime AssignedDate { get; set; }

        // Navigation properties
        public virtual User User { get; set; }
        public virtual Role Role { get; set; }
    }

    [Table("AuditLogs")]
    public class AuditLog
    {
        public AuditLog()
        {
            CreatedDate = DateTime.UtcNow;
        }

        public int Id { get; set; }

        public int? UserId { get; set; }

        [Required]
        [StringLength(100)]
        public string Action { get; set; }

        [StringLength(100)]
        public string EntityType { get; set; }

        public int? EntityId { get; set; }

        public string Details { get; set; }

        [StringLength(45)]
        public string IpAddress { get; set; }

        public string UserAgent { get; set; }

        public DateTime CreatedDate { get; set; }

        // Navigation properties
        public virtual User User { get; set; }
    }
}