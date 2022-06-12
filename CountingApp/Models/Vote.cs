using System.Text.Json.Serialization;

namespace CountingApp.Models;

public class Vote{

    public int? NumberCandidate { get; set; }
    
    [JsonIgnore]
    public DateTime CreatedAt { get; set; }
    
}
