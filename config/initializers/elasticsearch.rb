elasticsearch_config = Rails.application.config_for :elasticsearch

ENV["ELASTICSEARCH_URL"] = elasticsearch_config["url"]
Searchkick.index_prefix = "messaging_#{Rails.env}"
