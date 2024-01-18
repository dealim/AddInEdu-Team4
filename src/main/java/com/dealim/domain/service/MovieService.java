package com.dealim.domain.service;

import com.dealim.domain.model.Movie;
import com.dealim.domain.repository.MovieRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class MovieService {

    @Autowired
    MovieRepository movieRepository;
    public List<Movie> selectNowMovie() {

        return movieRepository.findAll();
    }

    public Optional<Movie> selectMovieDetailById(Long movieId) {
        return movieRepository.findById(movieId);
    }
}
