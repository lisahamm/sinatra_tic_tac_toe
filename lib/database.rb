require 'sequel'

module Database
  class << self
    def init!(config)
      database_url = build_database_url(config)
      @database = Sequel.connect(database_url)
    end

    def games
      @database[:games]
    end

    def game_by_id(id)
      @database[:games][id: id]
    end

    def save_game(game_hash)
      @database[:games].insert(game_hash)
    end

    private

    def build_database_url(config)
      "#{config["adapter"]}://#{config["host"]}/#{config["database"]}"
    end
  end
end