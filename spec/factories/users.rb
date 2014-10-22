FactoryGirl.define do
  factory :normal_user_1, class: User do
		email   		  "dreamou@zrquan.com"
    last_name  	  "欧阳"
    first_name	  "俊"
		encrypted_password	"12345678"
    confirmed_at  1.days.ago
    mentor_flag   false
  end

  factory :normal_user_2, class: User do
		email   		  "royfung@zqruan.com"
    last_name  	  "冯"
    first_name	  "庆强"
    confirmed_at  1.days.ago
    mentor_flag   false
  end

  factory :mentor_1, class: User do
    email   		  "fan.yuqi@zrquan.com"
    last_name  	  "樊"
    first_name	  "宇祺"
    confirmed_at  1.days.ago
    mentor_flag   true
  end

  factory :mentor_2, class: User do
    email   		  "lin.zhiling@zrquan.com"
    last_name  	  "林"
    first_name	  "志玲"
    confirmed_at  1.days.ago
    mentor_flag   true
  end

  factory :mentor_3, class: User do
    email   		  "gao.yuanyuan@zrquan.com"
    last_name  	  "高"
    first_name	  "圆圆"
    confirmed_at  1.days.ago
    mentor_flag   true
  end

  factory :unconfirmed_user, class: User do
    email   		  "fan.bingbing@zrquan.com"
    last_name  	  "范"
    first_name	  "冰冰"
  end
end
