using MongoDB.Driver;
using CandidatesAPI.Models;
using Microsoft.Extensions.Options;
using System.Security.Authentication;

namespace CandidatesAPI.Infrastructure;

public class CandidatesRepository{
    private readonly IMongoCollection<Candidate> candidateCollection;

    public CandidatesRepository(IOptions<CandidateDatabaseSettings> settings){        
        MongoClientSettings settingsMongo = MongoClientSettings.FromUrl(new MongoUrl(settings.Value.ConnectionString));
        settingsMongo.SslSettings = new SslSettings() { EnabledSslProtocols = SslProtocols.Tls12 };
        var mongoClient = new MongoClient(settings.Value.ConnectionString);
        var mongoDatabase = mongoClient.GetDatabase(settings.Value.DatabaseName);
        candidateCollection = mongoDatabase.GetCollection<Candidate>("Candidates");
        candidateCollection.Indexes.CreateOne(
                new CreateIndexModel<Candidate>(Builders<Candidate>.IndexKeys.Descending(model => model.Number),
                new CreateIndexOptions { Unique = true }));
    }
    
    public async Task<List<Candidate>> GetAllAsync() =>
        await candidateCollection.Find(_ => true).ToListAsync();

    public async Task<Candidate?> GetAsync(int number) =>
        await candidateCollection.Find(c => c.Number == number).FirstOrDefaultAsync();

    public async Task CreateAsync(Candidate candidate) =>
        await candidateCollection.InsertOneAsync(candidate);
}
