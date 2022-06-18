using System.Text.Json.Serialization;

namespace VotesAPI.Models;

public class VoteMessage{

    public int? NumberCandidate { get; set; }

    public string? NameCandidate { get; set; }

    public DateTime CreatedAt { get; set; }
}
