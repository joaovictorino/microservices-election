using System.Text.Json.Serialization;

namespace CountingWorker.Models;

public class Vote{

    public int? NumberCandidate { get; set; }
    
    public DateTime CreatedAt { get; set; }
    
}
