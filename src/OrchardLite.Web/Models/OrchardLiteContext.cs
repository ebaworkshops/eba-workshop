using System;
using System.Data.Entity;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using MySql.Data.EntityFramework;

namespace OrchardLite.Web.Models
{
    [DbConfigurationType(typeof(MySqlEFConfiguration))]
    public class OrchardLiteContext : DbContext
    {
        public OrchardLiteContext() : base("DefaultConnection")
        {
            Database.SetInitializer<OrchardLiteContext>(null);
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Role> Roles { get; set; }
        public DbSet<UserRole> UserRoles { get; set; }
        public DbSet<ContentItem> ContentItems { get; set; }
        public DbSet<ContentPart> ContentParts { get; set; }
        public DbSet<MediaItem> MediaItems { get; set; }
        public DbSet<Setting> Settings { get; set; }
        public DbSet<AuditLog> AuditLogs { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            // Configure User entity
            modelBuilder.Entity<User>()
                .HasKey(u => u.Id)
                .Property(u => u.Id)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            modelBuilder.Entity<User>()
                .Property(u => u.UserName)
                .IsRequired()
                .HasMaxLength(255);

            modelBuilder.Entity<User>()
                .Property(u => u.Email)
                .IsRequired()
                .HasMaxLength(255);

            modelBuilder.Entity<User>()
                .HasIndex(u => u.UserName)
                .IsUnique();

            modelBuilder.Entity<User>()
                .HasIndex(u => u.Email)
                .IsUnique();

            // Configure Role entity
            modelBuilder.Entity<Role>()
                .HasKey(r => r.Id)
                .Property(r => r.Id)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            modelBuilder.Entity<Role>()
                .Property(r => r.RoleName)
                .IsRequired()
                .HasMaxLength(100);

            modelBuilder.Entity<Role>()
                .HasIndex(r => r.RoleName)
                .IsUnique();

            // Configure UserRole entity (many-to-many)
            modelBuilder.Entity<UserRole>()
                .HasKey(ur => ur.Id);

            modelBuilder.Entity<UserRole>()
                .HasRequired(ur => ur.User)
                .WithMany(u => u.UserRoles)
                .HasForeignKey(ur => ur.UserId);

            modelBuilder.Entity<UserRole>()
                .HasRequired(ur => ur.Role)
                .WithMany(r => r.UserRoles)
                .HasForeignKey(ur => ur.RoleId);

            // Configure ContentItem entity
            modelBuilder.Entity<ContentItem>()
                .HasKey(c => c.Id)
                .Property(c => c.Id)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            modelBuilder.Entity<ContentItem>()
                .Property(c => c.Title)
                .IsRequired()
                .HasMaxLength(500);

            modelBuilder.Entity<ContentItem>()
                .Property(c => c.Slug)
                .IsRequired()
                .HasMaxLength(500);

            modelBuilder.Entity<ContentItem>()
                .HasRequired(c => c.Author)
                .WithMany(u => u.ContentItems)
                .HasForeignKey(c => c.AuthorId);

            // Configure ContentPart entity
            modelBuilder.Entity<ContentPart>()
                .HasKey(cp => cp.Id);

            modelBuilder.Entity<ContentPart>()
                .HasRequired(cp => cp.ContentItem)
                .WithMany(c => c.ContentParts)
                .HasForeignKey(cp => cp.ContentItemId);

            // Configure MediaItem entity
            modelBuilder.Entity<MediaItem>()
                .HasKey(m => m.Id);

            modelBuilder.Entity<MediaItem>()
                .HasRequired(m => m.UploadedBy)
                .WithMany(u => u.MediaItems)
                .HasForeignKey(m => m.UploadedById);

            // Configure Setting entity
            modelBuilder.Entity<Setting>()
                .HasKey(s => s.Id);

            modelBuilder.Entity<Setting>()
                .Property(s => s.SettingKey)
                .IsRequired()
                .HasMaxLength(255);

            modelBuilder.Entity<Setting>()
                .HasIndex(s => s.SettingKey)
                .IsUnique();

            // Configure AuditLog entity
            modelBuilder.Entity<AuditLog>()
                .HasKey(a => a.Id);

            modelBuilder.Entity<AuditLog>()
                .HasOptional(a => a.User)
                .WithMany(u => u.AuditLogs)
                .HasForeignKey(a => a.UserId);

            base.OnModelCreating(modelBuilder);
        }
    }
}