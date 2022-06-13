using System.Text.Json.Serialization;

namespace CountingApp.Models;

public class Vote{

    public int? NumberCandidate { get; set; }
    
    public DateTime CreatedAt { get; set; }
    
}
