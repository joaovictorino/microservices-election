using CountingApp.Models;

namespace CountingApp.Infrastructure;

public class VotesRepository{

    private DataContext context;

    public VotesRepository(DataContext context){
        this.context = context;
    }

    public void Create(Vote vote){
        context.Add(vote);
        context.SaveChanges();
    }
}
