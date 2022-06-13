using Microsoft.EntityFrameworkCore;
using ReportsAPI.Models;

namespace ReportsAPI.Infrastructure;

public class DataContext : DbContext {
    protected readonly IConfiguration configuration;

    public DataContext(IConfiguration configuration){
        this.configuration = configuration;
    }

    protected override void OnConfiguring(DbContextOptionsBuilder options){
        options.UseSqlServer(configuration.GetConnectionString("ReportsDatabase"));
    }

    public DbSet<Vote> Votes { get; set; }
}