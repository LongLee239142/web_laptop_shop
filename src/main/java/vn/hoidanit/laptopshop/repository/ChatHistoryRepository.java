package vn.hoidanit.laptopshop.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import vn.hoidanit.laptopshop.entity.ChatHistory;

@Repository
public interface ChatHistoryRepository extends JpaRepository<ChatHistory, Long> {
    @Query("SELECT ch FROM ChatHistory ch ORDER BY ch.timestamp DESC")
    List<ChatHistory> findAllOrderByTimestampDesc();
} 