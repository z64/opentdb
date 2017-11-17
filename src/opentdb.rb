require 'rest-client'
require 'json'

module OpenTDB
  # A Question data object
  class Question
    # @return [String] question category
    attr_reader :category

    # @return [String] question type
    attr_reader :type

    # @return [String] question difficulty
    attr_reader :difficulty

    # @return [String] question text
    attr_reader :question

    # @return [String] the correct answer
    attr_reader :correct_answer

    # @return [Array<String>] an array of possible incorrect answers
    attr_reader :incorrect_answers

    def initialize(data)
      @category          = data['category']
      @type              = data['type']
      @difficulty        = data['difficulty']
      @question          = data['question']
      @correct_answer    = data['correct_answer']
      @incorrect_answers = data['incorrect_answers']
    end

    # @param answer [String] attempted answer to this question
    # @return [true, false] whether answer matches (case-insensitive) the correct answer
    def correct?(answer)
      correct_answer.casecmp(answer).zero?
    end
  end

  # A persistant trivia session that will not repeat questions
  class Session
    attr_reader :token

    # Creates a new session, requesting a new session token internally
    def initialize
      @token = API.session
    end

    # Resets this sessions token
    def reset
      API.reset token
    end

    # Get questions
    # @return [Array<Question>]
    def get(amount, category: nil, difficulty: nil, type: nil, encoding: nil)
      response = API.questions(amount, token, API.category(category), difficulty, type, encoding)
      response['results'].map { |data| Question.new data } if response['results']
    end
  end

  module API
    # Base API URL for making requests
    API_URL = 'https://opentdb.com'

    # A map of category names to OpenTDB IDs
    CATEGORIES = {
      'General Knowledge'                     => 9,
      'Entertainment: Books'                  => 10,
      'Entertainment: Film'                   => 11,
      'Entertainment: Music'                  => 12,
      'Entertainment: Musicals & Theatres'    => 13,
      'Entertainment: Television'             => 14,
      'Entertainment: Video Games'            => 15,
      'Entertainment: Board Games'            => 16,
      'Science & Nature'                      => 17,
      'Science: Computers'                    => 18,
      'Science: Mathematics'                  => 19,
      'Mythology'                             => 20,
      'Sports'                                => 21,
      'Geography'                             => 22,
      'History'                               => 23,
      'Politics'                              => 24,
      'Art'                                   => 25,
      'Celebrities'                           => 26,
      'Animals'                               => 27,
      'Vehicles'                              => 28,
      'Entertainment: Comics'                 => 29,
      'Science: Gadgets'                      => 30,
      'Entertainment: Japanese Anime & Manga' => 31,
      'Entertainment: Cartoon & Animations'   => 32
    }

    module_function

    # Helper to get category ID from title (exact match)
    def category(title)
      CATEGORIES[title]
    end

    # Executes a generic GET request
    # @param route [String] the route to append to API_URL for this request
    # @param params [Hash] querystring params
    # @return [Hash] the response
    def get(route = '', params = {})
      response = RestClient.get "#{API_URL}/#{route}", params: params
      JSON.parse response
    end

    # Request a collection of questions based on criteria
    # @param amount [Integer] amount of questions to return (up to 50)
    # @param token [String] session token
    # @param category [Integer] category ID to limit trivia to (omit for any category)
    # @param difficulty [String] 'easy', 'medium', or 'hard' (omit for any difficulty)
    # @param type [String] 'multiple' or 'boolean'
    # @param encoding [String] 'default', 'urlLegacy', 'url3986', or 'base64'
    # @return [Hash] API response
    def questions(amount = nil, token = nil, category = nil, difficulty = nil, type = nil, encoding = nil)
      get('api.php', {
        amount: amount,
        token: token,
        category: category,
        difficulty: difficulty,
        type: type,
        encode: encoding
      }.compact)
    end

    # Requests a new session token from the API
    # @return [String] token
    def session
      response = get('api_token.php', command: 'request')
      response['token']
    end

    # Resets a session token
    def reset(token)
      get('api_token.php', command: 'reset', token: token)
    end
  end
end
