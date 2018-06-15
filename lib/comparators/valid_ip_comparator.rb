class ValidIpComparator < Comparator

  private

  REGEXP = /^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/i

  def success?(source)
    !!REGEXP.match(source)
  end

  def error_message(source)
    I18n.t 'valid_ip.failure', actual: source
  end
end
