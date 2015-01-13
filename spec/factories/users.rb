FactoryGirl.define do
  factory :normal_user_1, class: User do
		email   		  "dreamou@zrquan.com"
    name	        "欧阳俊"
    password	    "12345678"
    password_confirmation	   "12345678"
    confirmed_at  1.days.ago
  end

  factory :normal_user_2, class: User do
		email   		  "royfung@zqruan.com"
    name  	  "冯庆强"
    password	    "12345678"
    password_confirmation	   "12345678"
    confirmed_at  1.days.ago
    verified_flag   false
  end

  factory :v_user_1, class: User do
    email   		  "fan.yuqi@zrquan.com"
    name	        "樊宇祺"
    password	    "12345678"
    password_confirmation	   "12345678"
    confirmed_at  1.days.ago
    verified_flag   true
  end

  factory :v_user_2, class: User do
    email   		  "lin.zhiling@zrquan.com"
    name  	      "林志玲"
    password	    "12345678"
    password_confirmation	   "12345678"
    confirmed_at  1.days.ago
    verified_flag   true
  end

  factory :v_user_3, class: User do
    email   		  "gao.yuanyuan@zrquan.com"
    name  	      "高圆圆"
    password	    "12345678"
    password_confirmation	   "12345678"
    confirmed_at  1.days.ago
    verified_flag   true
  end

  factory :unconfirmed_user, class: User do
    email   		  "fan.bingbing@zrquan.com"
    name  	      "范冰冰"
    password	    "12345678"
    password_confirmation	   "12345678"
  end
end
