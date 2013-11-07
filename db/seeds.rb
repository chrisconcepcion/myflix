tv_comedy = Category.create(name: 'TV Comedies')
tv_drama = Category.create(name: 'TV Drama')
Video.create(title: 'South Park', description: 'Funny series', small_cover_url: 'south_park.jpg', large_cover_url: 'south_park.jpg', category_id: tv_comedy.id)
Video.create(title: 'Monk', description: 'Detective series', small_cover_url: 'monk.jpg', large_cover_url: 'monk_large.jpg', category_id: tv_drama.id)