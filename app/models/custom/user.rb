require_dependency Rails.root.join("app/models/user").to_s

class User

  def skip_level_two_verification?
    Setting["feature.user.skip_level_two_verification"].present?
  end
    

  def verification_sms_sent?
    return true if skip_level_two_verification?
    super
  end

  def sms_verified?
    return true if skip_level_two_verification?
    super
  end

  def verification_letter_sent?
    return true if skip_level_two_verification?
    super
  end

  def level_two_verified?
    return true if skip_verification?
    return residence_verified? if skip_level_two_verification?
    super
  end

  def level_three_verified?
    return true if skip_verification?
    return residence_verified? if skip_level_two_verification?
    super
  end
end