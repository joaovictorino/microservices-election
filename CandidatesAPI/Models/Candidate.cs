using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace CandidatesAPI.Models;

public class Candidate {

    [BsonId]
    [BsonRepresentation(BsonType.ObjectId)]
    public string? Id {get; set;}
    public string Name {get;set;}
    public int Number {get;set;}
    public DateTime BirthDate {get;set;}
    
}
