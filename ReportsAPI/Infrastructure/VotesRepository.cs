namespace ReportsAPI.Infrastructure;
using ReportsAPI.Models;

public class VotesRepository{

    private DataContext context;

    public VotesRepository(DataContext context){
        this.context = context;
    }

    public List<Report> GetAll(){
        return context.Votes
                        .GroupBy(p => new { p.NumberCandidate, p.NameCandidate })
                        .Select(r => new Report { NameCandidate = r.Key.NameCandidate, NumberCandidate = r.Key.NumberCandidate, Count = r.Count() })
                        .ToList();
    }
}