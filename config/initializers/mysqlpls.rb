require 'active_record/connection_adapters/abstract_mysql_adapter'

# 解决设置mysql的utf8mb4后varchar index的最大长度被超过问题，将string的默认长度从255改成191
# https://github.com/rails/rails/issues/9855
module ActiveRecord
  module ConnectionAdapters
    class AbstractMysqlAdapter
      NATIVE_DATABASE_TYPES[:string] = { :name => "varchar", :limit => 191 }
    end
  end
end