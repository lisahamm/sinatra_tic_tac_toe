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

    def update_game_moves(id, moves)
      @database[:games].where('id = ?', id).update(:moves => moves)
    end

    def update_game_current_player(id, current_player_mark)
      @database[:games].where('id = ?', id).update(:current_player_mark => current_player_mark)
    end

    private

    def build_database_url(config)
      "#{config["adapter"]}://#{config["host"]}/#{config["database"]}"
    end
  end
end