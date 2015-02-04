module PostSql
  ALL_COMMENTS =
      "select
          pc.id,
          pc.content,
          pc.agree_score,
          pc.created_at,
          u.name as comment_user_name,
          u.avatar,
          rpu.name as replied_user_name
        from
          post_comments pc
          inner join users u on (pc.user_id = u.id)
          left join post_comments rp on (pc.replied_comment_id = rp.id)
          left join users rpu on (rp.user_id = rpu.id)
        where pc.post_id = ?
        order by pc.created_at DESC"

  HOT_COMMENTS =
      "select
          pc.id,
          pc.content,
          pc.agree_score,
          pc.created_at,
          u.name as comment_user_name,
          u.avatar,
          rpu.name as replied_user_name
        from
          post_comments pc
          inner join users u on (pc.user_id = u.id)
          left join post_comments rp on (pc.replied_comment_id = rp.id)
          left join users rpu on (rp.user_id = rpu.id)
        where pc.post_id = ?
        order by pc.actual_score DESC
        limit 10"

  DETAIL =
      "select
          p.content,
          p.created_at,
          u.name,
          u.avatar,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major
        from posts p inner join users u on (p.user_id = u.id)
        where p.id = ?"

  SUFFICIENT_DAYS =
      "select min(recent_days) as recent_days
        from post_stats ps
        where
          ps.user_id = ? and
          ps.following_act_count >= ?"

end