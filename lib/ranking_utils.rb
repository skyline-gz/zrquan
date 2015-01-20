module RankingUtils

  START_SECONDS = 1421640000  # unix timestamp convert from 2015-01-19 12:00:00

  # 计算热门问题排序的公式
  def self.question_hot(weight, epoch_time)
    seconds = epoch_time - 1421640000
    weight + (seconds / 7200)
  end

  # 计算热门轻讨论排序的公式
  def self.post_hot(weight, epoch_time)
    seconds = epoch_time - 1421640000
    weight + (seconds / 1800)
  end

end