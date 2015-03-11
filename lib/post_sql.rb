module PostSql

  CARDS_PER_PAGE = 20
  ALL_LIMIT = 500

  # def self.home_post_sql(sort_type, page)
  #   select_part =
  #       "select
  #           p2.content,
  #           p2.anonymous_flag,
  #           p2.created_at,
  #           p2.agree_score,
  #           p2.comment_count,
  #           p2.comment_agree,
  #           u.name as user_name,
  #           u.latest_company_name,
  #           u.latest_position,
  #           u.latest_school_name,
  #           u.latest_major,
  #           u.avatar,
  #           t.name as theme_name
  #       from
  #         POSTS p2 inner join
  #         (select
  #            pt.post_id,
  #            min(pt.theme_id) as theme_id
  #          from
  #          POST_THEMES pt
  #          inner join THEME_FOLLOWS tf on (pt.theme_id = tf.theme_id and tf.user_id = ?)
  #          group by pt.post_id
  #          order by null
  #         ) t1 on p2.id = t1.post_id
  #         inner join THEMES t on t1.theme_id = t.id
  #         inner join USERS u on p2.user_id = u.id "
  #
  #   where_part = "where p2.PUBLISH_DATE >= ? "
  #
  #   order_part = ""
  #   if sort_type == "hot"
  #     order_part = "order by p2.hot desc "
  #   elsif sort_type == "new"
  #     order_part = "order by p2.created_at desc "
  #   end
  #
  #   # start = CARDS_PER_PAGE * (page - 1)
  #   limit_part = "limit " + ALL_LIMIT.to_s
  #
  #   select_part + where_part + order_part + limit_part
  # end

  def self.home_post_ids(sort)
    select_part =
        "select distinct
          pt.post_id
         from
          POST_THEMES pt
          inner join THEME_FOLLOWS tf on (pt.theme_id = tf.theme_id and tf.user_id = ?) "

    where_part = "where pt.created_at >= ? "

    order_part = ""
    if sort == "hot"
      order_part = "order by pt.hot desc "
    elsif sort == "new"
      order_part = "order by pt.created_at desc "
    end

    limit_part = "limit " + ALL_LIMIT.to_s

    select_part + where_part + order_part + limit_part
    # select_part + order_part + limit_part
  end

  HOME_POST_SQL =
      "select
        p2.content as post_content,
        p2.anonymous_flag as post_anonymous_flag,
        p2.created_at as post_created_at,
        p2.comment_count,
        p2.comment_agree,
        p2.agree_score as post_agree_score,
        pu.name as post_user_name,
        ifnull(pu.latest_company_name, pu.latest_school_name) as post_user_prop1,
        ifnull(pu.latest_position, pu.latest_major) as post_user_prop2,
        pu.avatar as post_user_avatar,
        t.name as theme_name,
        pc.content as comment_content,
        pc.created_at as comment_created_at,
        pc.agree_score as comment_agree_score,
        pcu.name as comment_user_name,
        ifnull(pcu.latest_company_name, pcu.latest_school_name) as comment_user_prop1,
        ifnull(pcu.latest_position, pcu.latest_major) as comment_user_prop2,
        pcu.avatar as comment_user_avatar
      from
        POSTS p2 inner join
        (select
           pt.post_id,
           min(pt.theme_id) as theme_id
        from
          POST_THEMES pt
        where pt.post_id in (?)
        group by pt.post_id
        order by null
        ) t1 on p2.id = t1.post_id
        inner join USERS pu on p2.user_id = pu.id
        inner join POST_COMMENTS pc on p2.hottest_comment_id = pc.id
        inner join USERS pcu on pc.user_id = pcu.id
        inner join THEMES t on t1.theme_id = t.id
        order by p2.hot desc"

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

  COMMENT_ID_AND_SCORE =
      "select
          pc.id,
          pc.actual_score
        from
          post_comments pc
        where pc.id = ?"

end