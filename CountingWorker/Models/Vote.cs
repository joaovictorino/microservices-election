using System.Text.Json.Serialization;

namespace CountingWorker.Models;

public class Vote{

    public int Id { get; set; }

    public int? NumberCandidate { get; set; }

    public string NameCandidate { get; set; }
    
    public DateTime CreatedAt { get; set; }
    
}
