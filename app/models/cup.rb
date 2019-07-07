class Cup < ActiveRecord::Base
    belongs_to :user
    belongs_to :coffee

    validates :brew, :coffee, :user, presence: true
    validates_associated :coffee

    def sip_time
        self.created_at.strftime("%A, %B %-d, %Y at %l:%M%P UTC")
    end

    def sip_date
        self.created_at.strftime("%A, %B %-d, %Y")
    end

    def a_or_an
        brew.start_with?(/[aeiou]/) ? 'an' : 'a'
    end

end
