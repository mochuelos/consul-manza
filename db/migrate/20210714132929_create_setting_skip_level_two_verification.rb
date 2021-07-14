class CreateSettingSkipLevelTwoVerification < ActiveRecord::Migration[5.2]
  def up
    s = Setting.new(key: "feature.user.skip_level_two_verification", value: true)
    s.save!
  end

  def down
    s = Setting.find_by(key: "feature.user.skip_level_two_verification")
    s.destroy!
  end
end
