require 'sequel'

module Database
  class << self
    def init!(config)
      database_url = build_database_url(config)
      @database = Sequel.connect(database_url)
    end

    def save_game(game_hash)
      @database[:games].insert(game_hash)
    end

    def games
      @database[:games]
    end

    def completed_games
      @database[:games].where('completed = true')
    end

    def game_by_id(id)
      @database[:games][id: id]
    end

    def update_after_turn(id, moves, current_player_mark, completed)
      @database[:games].where('id = ?', id).update(:moves => moves,
                                                   :current_player_mark => current_player_mark,
                                                   :completed => completed)
    end

    private

    def build_database_url(config)
      "#{config["adapter"]}://#{config["host"]}/#{config["database"]}"
    end
  end
end