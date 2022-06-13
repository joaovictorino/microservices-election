using System.Text.Json.Serialization;

namespace ReportsAPI.Models;

public class Report{
    public int NumberCandidate { get; set; }
    public string NameCandidate { get; set; }
    public int Count { get; set; }
}
