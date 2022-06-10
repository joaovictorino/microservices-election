namespace VotesAPI.Infrastructure;
using VotesAPI.Models;

public class VotesRepository{

    private DataContext context;

    public VotesRepository(DataContext context){
        this.context = context;
    }

    public async Task CreateAsync(Vote vote){
        await context.AddAsync(vote);
        await context.SaveChangesAsync();
    }
}
