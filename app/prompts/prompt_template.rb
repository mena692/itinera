class PromptTemplate
  PROMPTS_ROOT = Rails.root.join("app/prompts")

  def self.read(relative_path)
    PROMPTS_ROOT.join("#{relative_path}.txt").read
  end
end
