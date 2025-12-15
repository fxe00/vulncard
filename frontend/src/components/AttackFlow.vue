<template>
  <div>
    <h4 :style="{ color: '#2c3e50', margin: '20px 0 15px', fontSize: '16px' }">
      <i :class="`fas ${section.icon}`"></i> {{ section.title }}
    </h4>
    <div class="attack-flow">
      <template v-for="(step, index) in section.steps" :key="index">
        <div class="flow-step">
          <div class="step-number">{{ index + 1 }}</div>
          <div class="step-desc">{{ step }}</div>
        </div>
        <div v-if="index < section.steps.length - 1" class="flow-arrow">
          <i class="fas fa-arrow-right"></i>
        </div>
      </template>
    </div>
  </div>
</template>

<script>
export default {
  name: 'AttackFlow',
  props: {
    section: {
      type: Object,
      required: true
    }
  }
}
</script>

<style scoped>
.attack-flow {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin: 20px 0;
  gap: 10px;
  flex-wrap: wrap;
}

.flow-step {
  text-align: center;
  flex: 1;
  min-width: 0;
  position: relative;
}

.step-number {
  width: 36px;
  height: 36px;
  background: #3498db;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  margin: 0 auto 10px;
  font-size: 16px;
  flex-shrink: 0;
}

.step-desc {
  font-size: 13px;
  color: #555;
  line-height: 1.4;
  word-wrap: break-word;
  overflow-wrap: break-word;
}

.flow-arrow {
  color: #3498db;
  font-size: 18px;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  padding: 0 5px;
}

@media (max-width: 1024px) {
  .attack-flow {
    flex-wrap: wrap;
    gap: 20px;
  }

  .flow-step {
    flex: 0 0 calc(50% - 10px);
  }

  .flow-arrow {
    display: none;
  }
}

@media (max-width: 768px) {
  .flow-step {
    flex: 0 0 100%;
  }
}
</style>
