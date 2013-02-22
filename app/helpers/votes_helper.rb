module VotesHelper
	def vote_count(post)
		status = 'No one likes this yet'
		if post.votes.any?
			status = pluralize(post.votes.size, "like")
		end
		status
	end
	
	def i_voted(post, current_user)
    @myvote = nil
		iVoted = false
		post.votes.each do |vote|
			logger.info "#{vote.login}"
			if vote.login == current_user.login
				iVoted = true
        @myvote = vote
			end
		end
		iVoted
	end
end
