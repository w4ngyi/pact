module PactTaskHelper
  def failure_message
    redify(
      "\n* * * * * * * * * * * * * * * * * * *\n" +
      "Provider did not honour pact file.\nSee\n * #{Pact.configuration.log_path}\n * #{Pact.configuration.tmp_dir}\nfor logs and pact files." +
      "\n* * * * * * * * * * * * * * * * * * *\n\n"
    )
  end

  def redify string
    "\e[31m#{string}\e[m"
  end
end