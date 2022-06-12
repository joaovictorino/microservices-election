using System.Text.Json.Serialization;

namespace VotesAPI.Models;

public class Vote{

    public int? NumberCandidate { get; set; }
    
    [JsonIgnore]
    public DateTime CreatedAt { get; set; }
    
}
