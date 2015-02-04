module ThemeSql

  ALL_QUESTIONS =
      "select
          q.title,
          q.anonymous_flag,
          q.created_at,
          q.answer_count,
          q.answer_agree,
          q.follow_count,
          u.name as user_name,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major,
          u.avatar,
          t.name as theme_name
        from
          QUESTIONS q inner join QUESTION_THEMES qt on q.id = qt.question_id
          inner join ANSWERS a on q.id = a.question_id
          inner join USERS u on q.user_id = u.id
          inner join THEMES t on t.id = qt.theme_id
        where
          qt.theme_id = ?
        order by q.created_at
        limit 20"

  ALL_POSTS =
      "select
          p.content,
          p.anonymous_flag,
          p.created_at,
          p.agree_score,
          p.comment_count,
          p.comment_agree,
          u.name as user_name,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major,
          u.avatar,
          t.name as theme_name
        from
          POSTS p inner join POST_THEMES pt on p.id = pt.post_id
          inner join USERS u on p.user_id = u.id
          inner join THEMES t on t.id = pt.theme_id
        where
          pt.theme_id = ?
        order by p.created_at
        limit 20"

  SCHOOL_ALUMNUS =
      "select
          u.name as user_name,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major,
          u.avatar,
          u.description
        from
          schools s
          inner join educations e on s.id = e.school_id
          inner join users u on e.id = u.latest_education_id
        where
          s.id = ?
        order by u.created_at desc"

  REGION_USERS =
      "select
          u.name as user_name,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major,
          u.avatar,
          u.description
        from
          users u
          inner join locations l on u.location_id = l.id
        where
          l.region_id = ?
        order by u.created_at desc"

  LOCATION_USERS =
      "select
          u.name as user_name,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major,
          u.avatar,
          u.description
        from
          users u
        where
          u.location_id = ?
        order by u.created_at desc"

  INDUSTRY_USERS =
      "select
          u.name as user_name,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major,
          u.avatar,
          u.description
        from
          users u
        where
          u.industry_id = ?
        order by u.created_at desc"

  COMPANY_USERS =
      "select
          u.name as user_name,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major,
          u.avatar,
          u.description
        from
          companies com
          inner join careers car on com.id = car.company_id
          inner join users u on car.id = u.latest_career_id
        where
          com.id = ?
        order by u.created_at desc"

end