namespace VotesAPI.Models;
using System.Text.Json.Serialization;
public class Candidate {

    [JsonPropertyName("name")]
    public string Name {get;set;}
    
    [JsonPropertyName("number")]
    public int Number {get;set;}
    
    [JsonPropertyName("birhDate")]
    public DateTime BirthDate {get;set;}
    
}
