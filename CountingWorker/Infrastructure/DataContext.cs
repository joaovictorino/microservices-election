using Microsoft.EntityFrameworkCore;
using CountingWorker.Models;
using Microsoft.Extensions.Configuration;

namespace CountingWorker.Infrastructure;

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