class Interaction < ActiveRecord::Base
  
  belongs_to  :user
  has_many    :answers, dependent:  :destroy
  has_many    :goals
  has_many    :improvements
  
  before_create :assign_question_answers
  
  validates :user_id, presence: true
  
  scope :completed,   -> { where(completed: true).order(updated_at: :desc) }
  
  CRUCENDO_STREAK_DAYS_SQL = <<-SQL
    SELECT (:yesterday - series_date::date) AS days
    FROM generate_series(
      ( SELECT (updated_at AT TIME ZONE :zone_offset)::date FROM interactions
        WHERE interactions.user_id = :user_id
        AND interactions.completed = true
        ORDER BY updated_at ASC
        LIMIT 1
      ) - INTERVAL '1 day',
      :yesterday,
      '1 day'
    ) AS series_date
    LEFT OUTER JOIN interactions 
    ON interactions.user_id = :user_id 
    AND (interactions.updated_at AT TIME ZONE :zone_offset)::date = series_date
    AND interactions.completed = true
    GROUP BY series_date
    HAVING COUNT(interactions.id) = 0
    ORDER BY series_date DESC
    LIMIT 1
  SQL
  
  def self.interaction_streak_days(user_id)
    sql = sanitize_sql [ CRUCENDO_STREAK_DAYS_SQL, 
      { user_id: user_id, 
        zone_offset: Time.zone.now.formatted_offset,
        yesterday: Date.yesterday} ]
    result_value = connection.select_value(sql)
    Integer(result_value) rescue nil
  end
  
  # find first linked answer that is incomplete
  def find_next_answer
    answers.where(:encrypted_answer => nil).first
  end
  
  # Check if criteria have been met to complete this interaction
  def ready_to_complete?
    answers.where(:encrypted_answer => nil).blank?
  end
  
  def missing_answers
    answers.where(:encrypted_answer => nil).order(:id).first
  end
  
  # set interaction as completed
  def complete
    update_attribute(:completed, true)
  end
  
  private
  
    # assign questions to interaction
    def assign_question_answers
      
      @topics_answered = user.topics
                          .eager_load(questions: {answers: :interaction } )
                          .where(interactions: {user_id: user.id})
                          .order("answers.created_at DESC")
                          
      topics_answered_ids = @topics_answered.pluck(:id)
      
      @topics_remainder = user.topics.where.not(id: topics_answered_ids).order("RANDOM()")
      
      @topics_all = @topics_answered + @topics_remainder
      
      @topics_hash = @topics_all.map{ |t| [t, (@topics_all.index(t)+1) ** 2] }.to_h
      @topics_hash = @topics_hash.to_a.reverse.to_h
      
      @topics_shuffled = shuffle(@topics_hash)
      
      @topics_shuffled.each do |topic|
        if question = topic.find_next_question(user)
          answers.build(question_id: question.id, user_id: user.id)
        end
        break if answers.size >= 3
      end
    end

  def shuffle some_hash
    result = []
    
    numbers = some_hash.keys
    weights = some_hash.values
    total_weight = weights.reduce(:+)
    
    # choose numbers one by one
    until numbers.empty?
      # weight from total range of weights
      selection = rand() * total_weight
    
      # find which element this corresponds with
      i = 0
      while selection > 0
         selection -= weights[i]
         i += 1
      end
      i -= 1
    
      # add number to result and remove corresponding weight
      result << numbers[i]
      numbers.delete_at i
      total_weight -= weights.delete_at(i)
    end
    
    result
  end
end
