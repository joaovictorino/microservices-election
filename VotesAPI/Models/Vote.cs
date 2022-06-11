using System.Text.Json.Serialization;

namespace VotesAPI.Models;

public class Vote{

    [JsonIgnore]
    public int Id {get;set;}
    public int? NumberCandidate { get; set; }
    
    [JsonIgnore]
    public DateTime CreatedAt { get; set; }
    
}
