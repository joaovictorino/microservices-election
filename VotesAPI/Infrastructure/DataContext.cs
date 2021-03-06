using Microsoft.EntityFrameworkCore;
using VotesAPI.Models;

namespace VotesAPI.Infrastructure;

public class DataContext : DbContext {
    protected readonly IConfiguration configuration;

    public DataContext(IConfiguration configuration){
        this.configuration = configuration;
    }

    protected override void OnConfiguring(DbContextOptionsBuilder options){
        options.UseSqlServer(configuration.GetConnectionString("VotesDatabase"));
    }

    public DbSet<Vote> Votes { get; set; }
}
