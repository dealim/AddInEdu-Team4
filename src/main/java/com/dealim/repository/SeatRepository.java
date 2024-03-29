package com.dealim.repository;

import com.dealim.domain.Seat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface SeatRepository extends JpaRepository<Seat, Long> {
    boolean existsByMovieIdAndTheaterIdAndSeatNumber(Long movieId, Long theaterId, Integer seatNumber);

    @Query("SELECT s.seatNumber FROM Seat s WHERE s.movieId = :movieId AND s.theaterId = :theaterId AND s.ticketedDate = :ticketedDate")
    List<Integer> getTakenSeats(@Param("movieId") Long movieId, @Param("theaterId") Long theaterId, @Param("ticketedDate") LocalDateTime ticketedDate);
    void deleteByTicketId(Long ticketId);
}