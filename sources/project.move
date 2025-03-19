module MyModule::NewsPlatform {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a news story.
    struct Story has store, key {
        votes: u64,      // Number of votes for the story
        reward: u64,     // Reward allocated to the story creator
    }

    /// Function to submit a news story with an initial reward.
    public fun submit_story(creator: &signer, reward: u64) {
        let story = Story {
            votes: 0,
            reward,
        };
        move_to(creator, story);
    }

    /// Function to vote on a story and reward the creator.
    public fun vote_for_story(voter: &signer, creator_address: address, amount: u64) acquires Story {
        let story = borrow_global_mut<Story>(creator_address);

        // Increase the vote count
        story.votes = story.votes + 1;

        // Transfer reward to the story creator
        let reward_amount = coin::withdraw<AptosCoin>(voter, amount);
        coin::deposit<AptosCoin>(creator_address, reward_amount);
    }
}
