namespace ReportsAPI.Infrastructure;
using ReportsAPI.Models;

public class VotesRepository{

    private DataContext context;

    public VotesRepository(DataContext context){
        this.context = context;
    }

    public List<Vote> GetAll(){
        return context.Votes.AsQueryable().ToList();
    }
}