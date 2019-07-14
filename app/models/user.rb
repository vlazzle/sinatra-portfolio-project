class User < ActiveRecord::Base
    has_secure_password
    has_many :cups 
    has_many :coffees, through: :cups
    before_validation :normalize_name
    validates :email, {presence: true, uniqueness: { case_sensitive: false }}
    validates :name, :password, presence: true

    def slug
        self.name.downcase.strip.gsub(' ', '-').gsub('&', 'and').gsub(/[^\w-]/, '')
    end
    
    def self.find_by_slug(slug)
        # you're not using this and a few other find_by_slugs,
        # it's better to delete code that you're not using to make the rest of the code easier to read.
        # You can always find the deleted code in the git history.
        self.all.find {|user| user.slug == slug}
    end

    private
        def normalize_name
            self.name = name.split(' ').map {|w| w.downcase.capitalize}.join(' ')
        end
end