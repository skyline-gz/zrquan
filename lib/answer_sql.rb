module AnswerSql

  DETAIL =
      "select
          a.content,
          a.created_at,
          q.title as question_title
          u.name,
          u.avatar,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major
        from
          answers a inner join users u on (a.user_id = u.id)
          inner join questions q on (a.question_id = q.id)
        where a.id = ?"

  SORTED_COMMENTS =
      "select
          c.content,
          c.created_at,
          u.name,
          u.avatar,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major
        from comments c inner join users u on (c.user_id = u.id)
        where c.commentable_id = ? and c.commentable_type = 'Answer'
        order by c.created_at DESC"

end