class UserSetupValidation
  attr_reader :errors

  def initialize(setup)
    @setup = setup
    @errors = {}
  end

  def valid?
    run_validations
    errors.empty?
  end

  def invalid?
    !valid?
  end

  private

  def run_validations
    validate(:player_mark)
    validate(:computer_opponent)
    validate(:player_order)
  end

  def validate(key)
    if valid_options[key].include?(@setup[key])
      true
    else
      self.errors[key] = message_options[key]
      false
    end
  end

  def valid_options
    {
      player_mark: ["X", "O"],
      computer_opponent: ["yes", "no"],
      player_order: ["first", "second"]
    }
  end

  def message_options
    {
      player_mark: "Please select a mark to continue",
      computer_opponent: "Please indicate if you would like to play against the computer",
      player_order: "Please select if you would like to go first or second"
    }
  end
end