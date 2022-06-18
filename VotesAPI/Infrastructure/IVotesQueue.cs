using VotesAPI.Models;

namespace VotesAPI.Infrastructure;

public interface IVotesQueue {
    void Send(VoteMessage vote);
}